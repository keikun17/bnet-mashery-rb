class Mashery::BnetResource
  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def self.from_api(raw_response)
    new_hash = {}
    params_mapping.each do |old_key, new_key|
      if raw_response.has_key?(old_key)
        new_hash[new_key] = raw_response[old_key]
      end
    end

    bnet_resource = self.new(new_hash)
  end

  private

  def self.params_mapping
    self::PARAMS_MAPPING
  end

end
