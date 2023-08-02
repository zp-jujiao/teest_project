# encoding: utf-8
require 'grape-swagger'

module AppApi
  class API < Grape::API
    content_type :json, 'application/json;charset=utf-8'
    format :json

    helpers APIHelpers::ApplicationHelpers


    #单词本
    mount AppApi::V1::Book
    #生词本
    mount AppApi::V1::New_Book


    add_swagger_documentation add_version: true, mount_path: '/v1/apidoc'
  end
end
