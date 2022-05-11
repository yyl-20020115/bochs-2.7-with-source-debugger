#include "srcshow.h"
#include "bfdconfig.h"
#include "bfd.h"
#define HAVE_DECL_BASENAME 1
#include <libiberty/libiberty.h>
#include <malloc.h>
#include <string>
#include <fstream>

std::string last_path;
int get_elf_path(std::string& p)
{
    p = last_path;
    return p.size();
}
/* These global variables are used to pass information between
   translate_addresses and find_address_in_section.  */

static const char *filename =0;
static const char *functionname =0;
static unsigned int line =0;

static bfd_vma pc=0;
static unsigned int discriminator=0;
static bfd_boolean found=0;
static asymbol **syms=0;		/* Symbol table.  */
static bfd *abfd = 0;
unsigned int get_line()
{
    return line;
}

const char* get_filename()
{
    return filename;
}
const char* get_functionname()
{
    return functionname;
}
/* Returns the size of the named file.  If the file does not
   exist, or if it is not a real file, then a suitable non-fatal
   error message is printed and (off_t) -1 is returned.  */

static off_t
get_file_size ( const char * file_name )
{
    struct stat statbuf;

    if ( file_name == NULL )
        return ( off_t ) -1;

    if ( stat ( file_name, &statbuf ) == 0 ) {
        return statbuf.st_size;
    }


    return ( off_t ) -1;
}


/* Read in the symbol table.  */

static int slurp_symtab ( bfd *abfd )
{
    long storage;
    long symcount;
    bfd_boolean dynamic = FALSE;

    if ( ( bfd_get_file_flags ( abfd ) & HAS_SYMS ) == 0 )
        return 1;

    storage = bfd_get_symtab_upper_bound ( abfd );
    if ( storage == 0 ) {
        storage = bfd_get_dynamic_symtab_upper_bound ( abfd );
        dynamic = TRUE;
    }
    if ( storage < 0 )
        return 1;

    syms = ( asymbol ** ) xmalloc ( storage );
    if ( dynamic )
        symcount = bfd_canonicalize_dynamic_symtab ( abfd, syms );
    else
        symcount = bfd_canonicalize_symtab ( abfd, syms );
    if ( symcount < 0 ) {
        free ( syms );
        return 1;
    }

    /* If there are no symbols left after canonicalization and
       we have not tried the dynamic symbols then give them a go.  */
    if ( symcount == 0
            && ! dynamic
            && ( storage = bfd_get_dynamic_symtab_upper_bound ( abfd ) ) > 0 ) {
        free ( syms );
        syms = ( asymbol ** ) xmalloc ( storage );
        symcount = bfd_canonicalize_dynamic_symtab ( abfd, syms );
    }

    /* PR 17512: file: 2a1d3b5b.
       Do not pretend that we have some symbols when we don't.  */
    if ( symcount <= 0 ) {
        free ( syms );
        syms = NULL;
    }
    return 0;
}

/* Look for an address in a section.  This is called via
   bfd_map_over_sections.  */

static void find_address_in_section ( bfd *abfd, asection *section,
                                      void *data )
{
    bfd_vma vma;
    bfd_size_type size;

    if ( found )
        return;

    if ( ( bfd_section_flags ( section ) & SEC_ALLOC ) == 0 )
        return;

    vma = bfd_section_vma ( section );
    if ( pc < vma )
        return;

    size = bfd_section_size ( section );
    if ( pc >= vma + size )
        return;

    found = bfd_find_nearest_line_discriminator ( abfd, section, syms, pc - vma,
            &filename, &functionname,
            &line, &discriminator );
}


/* Read hexadecimal addresses from stdin, translate into
   file_name:line_number and optionally function name.  */

static bfd_boolean translate_address ( bfd *abfd, const char* addr_hex )
{
    pc = bfd_scan_vma ( addr_hex, NULL, 16 );
    found = FALSE;
    bfd_map_over_sections ( abfd, find_address_in_section, NULL );
    return found;
}
int translate_address ( const char* addr_hex )
{
    return abfd!=0 && translate_address ( abfd,addr_hex );
}


void unload_bfd();
int load_bfd ( const char *path )
{
    if ( path ==0 ) return 0;
    if ( last_path == path ) return 1;
    
    char **matching =0;

    if ( get_file_size ( path ) < 1 )
        return 0;
    unload_bfd();

    //bfd_set_default_target("x86_64-pc-linux-gnu");

    abfd = bfd_openr ( path, 0 );
    if ( abfd == NULL )
        return 0;

    /* Decompress sections.  */
    abfd->flags |= BFD_DECOMPRESS;

    if ( bfd_check_format ( abfd, bfd_archive ) ) {
        bfd_close ( abfd );
        return 0;
    }
    if ( ! bfd_check_format_matches ( abfd, bfd_object, &matching ) ) {

    }
    if ( matching ) {
        free ( matching );
    }
    slurp_symtab ( abfd );
    last_path=path;
    return 1;
}

void unload_bfd()
{
    if ( syms != 0 ) {
        free ( syms );
        syms = 0;
    }
    if ( abfd != 0 ) {
        bfd_close ( abfd );
        abfd = 0;
    }
}

int do_bfd_init()
{
    if ( bfd_init () != BFD_INIT_MAGIC )
        return 0;
    return 1;
}

static std::string last_file;

bool on_file(const char *path,std::vector<std::string>& lines)
{
    if(last_file!=path ||lines.size()==0)
    {
        load_lines(path,lines);
        last_file=path;
        return true;
    }
    return false;
}
size_t load_lines ( const char *path,std::vector<std::string>& lines )
{
    std::fstream file;
    std::string line;
    file.open ( path,std::ios_base::in );
    if(file.is_open()){
        lines.clear();
        while ( !file.eof() ) {
            getline (file,line );
            lines.push_back ( line );
        }
    }
    return lines.size();
}
