#include <iostream>

#include "options.h"
#include "webserver.h"

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Invalid number of arguments. Usage: webserver <config_file>\n";
        return 1;
    }

    Options opt;
    short port_num = opt.getPort(argv[1]);
    std::cout << "configured port: " << port_num << std::endl;

    Webserver ws;
    ws.run();

    return 0;
}