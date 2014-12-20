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

      repl_eval(request.remote_addr, code)
    rescue Exception => e
      {
        html: "<span style=\"color: red\">#{e.class}: #{e.message}</span>",
        complete: true
      }
    end

    respond_to do |f|
      f.js do
        render json: val.to_json
      end
    end
  end

end
