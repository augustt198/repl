BINDING_LOOKUP = Hash.new { |h, k| h[k] = proc {}.binding }


options = YAML::load_file(Rails.root.join('config', 'redis.yml')) rescue {}
options ||= {}

REDIS = Redis.new options
