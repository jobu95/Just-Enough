#pragma once
#include "request_handler.h"

#include <map>
#include <memory>
#include <string>

class Module {
    public:
        Module(std::string path) : path_(path) {}
        virtual ~Module() = default;
        virtual bool handleRequest(const Request& req, Response* resp) = 0;
        virtual bool matchesRequestPath(const std::string& str) const;

    protected:
        std::string path_;
        std::shared_ptr<std::map<std::string, std::string>> moduleParameters;
};

Module* createModuleFromParameters(std::shared_ptr<std::map<std::string, std::string>> params);
