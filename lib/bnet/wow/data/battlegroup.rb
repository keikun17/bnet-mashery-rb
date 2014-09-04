class Bnet::WOW::Data::Battlegroup < Bnet::WOW::Data::Base
  attr :name, :slug

  SCOPES = {
    url: 'battlegroups/',
    collection_root: 'battlegroups'
  }

  PARAMS_MAPPING = { "name" => :name, "slug" => :slug }

  private

  def self.scopes
    self::SCOPES
  end

end

