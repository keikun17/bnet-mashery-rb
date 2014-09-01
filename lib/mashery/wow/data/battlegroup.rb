class Mashery::WOW::Data::Battlegroup < Mashery::WOW::Data::Base

  attr :name, :slug

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
