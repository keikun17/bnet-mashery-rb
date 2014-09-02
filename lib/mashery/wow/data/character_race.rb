class Mashery::WOW::Data::CharacterRace < Mashery::WOW::Data::Base

  attr :race_id, :mask, :side, :name

  SCOPES = {
    url: 'character/races',
    collection_root: 'races'
  }

  PARAMS_MAPPING = {
    "id" => :race_id, "mask" => :mask,
    "side" => :side, "name" => :name
  }

end
