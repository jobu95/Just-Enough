#include "not_found_handler.h"
#include <iostream>

RequestHandler::Status NotFoundHandler::Init(const std::string& uri_prefix, const NginxConfig& config) {
    return RequestHandler::OK;
}

RequestHandler::Status NotFoundHandler::HandleRequest(const Request& req, Response* resp) {
    resp->SetStatus(Response::code_404_not_found);
    resp->SetBody("404 Not Found");
    resp->AddHeader("Content-Type", "text/plain");
    return RequestHandler::OK;
}
