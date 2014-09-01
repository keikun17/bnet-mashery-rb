class Mashery::WOW::Data::Battlegroup < Mashery::WOW::Data::Base

  attr :name, :slug

  def self.scope
    'battlegroups'
  end

  private

  def self.from_api(raw_hash)
    new_hash = {}
    association_hash ||= {}
    other_attributes ||= {}

    # NOTE common tasks below -- marker for easier method extraction
    params_mapping.each do |old_key, new_key|
      if response.has_key?(old_key)
        new_hash[new_key] = response[old_key]
      end
    end

    new_hash.merge!(association_hash)
    new_hash.merge!(other_attributes)
    new(new_hash)
    # NOTE end of common tasks
  end

  def self.params_mapping
    { "name" => :name, "slug" => :slug }
  end

  private

  def self.scopes
    {
      url: 'battlegroups',
      collection_root: 'battlegroups'
    }
  end

end
