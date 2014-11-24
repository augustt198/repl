class RubyController < ApplicationController

  def index
  end

  def ruby_eval


    val = begin
      json = JSON.parse request.body.gets

      # check access key
      access_key = json['access_key']
      if !access_key || !REDIS.sismember('access_keys', access_key)
        raise Exception.new "Invalid access key"
      end
      code = json['command']

      bind = BINDING_LOOKUP[request.remote_addr]
      bind.eval(code).ai html: true
    rescue Exception => e
      "<span style=\"color: red\">#{e.class}: #{e.message}</span>"
    end

    respond_to do |f|
      f.js do
        render json: {'html' => val}.to_json
      end
    end
  end

end
