class Mashery::BnetResource
  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def self.from_api(response)
    # NOTE common tasks below -- marker for easier method extraction
    new_hash = {}
    # association_hash ||= {}
    params_mapping.each do |old_key, new_key|
      if response.has_key?(old_key)
        new_hash[new_key] = response[old_key]
      end
    end

    # new_hash.merge!(association_hash)
    bnet_resource = self.new(new_hash)
  end
end
