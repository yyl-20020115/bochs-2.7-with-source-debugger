#ifndef SRCSHOW_H
#define SRCSHOW_H

#ifndef USE_SRCSHOW
#define USE_SRCSHOW
#endif

#include <vector>
#include <string>

int do_bfd_init();
int load_bfd(const char *path);
void unload_bfd();
int translate_address (const char* addr_hex);
unsigned int get_line();
const char* get_filename();
const char* get_functionname();

bool on_file(const char *path,std::vector<std::string>& lines);

size_t load_lines(const char *path,std::vector<std::string>& lines);

#endif
