bnet-mashery-rb
===============

Ruby gem for accessing Blizzard's Mashery API

This repository (will) contain various libraries for interfacing with *takes a deep breath* Blizzard's-Battle.net-Mashery- API.

This is a work in progress : [TODO-LIST](https://github.com/keikun17/bnet-mashery-rb/blob/master/TODO.md)

### Installation

    # Gemfile for your Rails / Sinatra project.
    gem 'bnet

## Configuration

    # initializer file (cnonfig/initializer/bnet_initializer.rb)
    Bnet.configuration.api_key = 'your_api_key'

## Diablo

### Career

    # Perform a query for the Diablo 3 character profile.
    #
    # Arguments
    #   Required
    #     :battle_tag - Player Battletag (ex. PlayerOne#1309)
    #     :region     - Account region (ex. 'us')
    #   Optional
    #     :locale     - String locale (default: 'en_US')
    #     :api_key    - String API key
    #
    # Returns a Career object with the following attributes
    #
    #    :heroes, :last_hero_played, :last_updated, :kills, :time_played,
    #    :fallen_heroes, :paragon_level, :paragon_level_hardcore, :battle_tag,
    #    :progression, :region
    #
    # Note : Autoloads the associated hero records from the Hero API as well

    Bnet::Diablo3::Career.find(battle_tag: 'PlayerOne#1309', region: 'us')

### Hero

    # Perform a query for the D3 career's hero
    #
    # Arguments
    #   Required
    #     :battle_tag - Player Battletag (ex. PlayerOne#1309)
    #     :region     - Account region (ex. 'us')
    #     :hero_id    - You can get this from an existing Career object
    #                   or from the website url when you view a hero
    #   Optional
    #     :locale     - String locale (default: 'en_US')
    #     :api_key    - String API key
    #
    # Example
    #
    #
    # Returns a Hero object with the following attributes
    #
    #  :paragon_level, :seasonal, :name, :hero_id,
    #  :level, :hardcore, :gender, :dead, :hero_class, :last_update,
    #  :active_skills, :passive_skills, :region, :battle_tag, :career

    Bnet::Diablo3::Hero.find(battle_tag: 'PlayerOne-1309', region: 'us', hero_id: 1304986)

### License


Licensed under the MIT license (see MIT-LICENSE file)
