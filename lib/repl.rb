# for parsing Ruby
require 'ripper'

# load redis config file
options = YAML::load_file(Rails.root.join('config', 'redis.yml')) rescue {}
options ||= {}

REDIS = Redis.new options


BINDING_LOOKUP = Hash.new { |h, k| h[k] = proc {}.binding }
BUF_LOOKUP     = Hash.new

def is_completed?(source)
  Ripper.sexp(source) ? true : false
end

def repl_eval(ip, source)
  buf = BUF_LOOKUP[ip]
  complete = false
  if source == 'clr'
    BUF_LOOKUP[ip] = nil
    res = 'Buffer Cleared'.ai html: true
    return {html: res, complete: true}
  end

  # something is in buffer
  if buf
    buf.concat("\n#{source}")
    p buf
    if is_completed?(buf)
      complete = true
      source = buf
      BUF_LOOKUP[ip] = nil
    end
  else
    if is_completed?(source)
      complete = true
    else
      BUF_LOOKUP[ip] = source
    end
  end

  if complete
    res = BINDING_LOOKUP[ip].eval(source).ai html: true
    {html: res, complete: true}
  else
    {complete: false}
  end
end
