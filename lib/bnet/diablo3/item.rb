class Bnet::Diablo3::Item < Bnet::BnetResource
  attr_accessor :item_id, :location, :name

  def self.from_api(location, raw_response)
    item = new(location: location)
    item.item_id = raw_response["id"]
    item.name = raw_response["name"]

    return item
  end
end
