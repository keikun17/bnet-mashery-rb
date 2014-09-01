class Mashery::WOW::Data::Battlegroup < Mashery::WOW::Data::Base
  attr :name, :slug

  SCOPES = {
    url: 'battlegroups',
    collection_root: 'battlegroups'
  }

  PARAMS_MAPPING = { "name" => :name, "slug" => :slug }

end

