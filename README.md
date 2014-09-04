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
    # Example
    #
    # Bnet::Diablo3.find(battle_tag: 'PlayerOne#1309', region: 'us')
    #
    # Returns a Career object with the following attributes
    #
    #    :heroes, :last_hero_played, :last_updated, :kills, :time_played,
    #    :fallen_heroes, :paragon_level, :paragon_level_hardcore, :battle_tag,
    #    :progression, :region
    #
    # Note : Autoloads the associated hero records from the Hero API as well

    Bnet::Diablo3.find(battle_tag: 'PlayerOne#1309', region: 'us')

### Hero

### License


Licensed under the MIT license (see MIT-LICENSE file)
