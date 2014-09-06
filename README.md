bnet-mashery-rb
===============

Ruby gem for accessing Blizzard's Mashery API

This repository (will) contain various libraries for interfacing with Blizzard's Battle.net API [https://dev.battle.net](https://dev.battle.net).

This is a work in progress : [TODO-LIST](https://github.com/keikun17/bnet-mashery-rb/blob/master/TODO.md)

### Installation

    # Gemfile for your Rails / Sinatra project.
    gem 'bnet'

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
    #    :life, :damage, :attack_speed, :armor, :strength, :dexterity, :vitality,
    #    :intelligence, :physical_resist, :fire_resist, :cold_resist,
    #    :lightning_resist, :poison_resist, :arcane_resist, :crit_damage,
    #    :block_chance, :block_amount_min, :block_amount_max, :damage_increase,
    #    :crit_chance, :damage_reduction, :thorns, :life_steal, :life_per_kill,
    #    :gold_find, :magic_find, :life_on_Hit, :primary_resource,
    #    :secondary_resource
    #
    #  and the following misc attributes
    #
    #    :paragon_level, :seasonal, :name, :hero_id,
    #    :level, :hardcore, :gender, :dead, :hero_class, :last_update,
    #    :active_skills, :passive_skills, :region, :battle_tag, :career,
    #    :items

    Bnet::Diablo3::Hero.find(battle_tag: 'PlayerOne-1309', region: 'us', hero_id: 1304986)

## Starcraft2

    # Query Battlenet API for the SC2 profile recordand create an instance of an
    # SC2 Profile.
    #
    # Hash Params:
    #   Required
    #     :realm      - (required but defaults to '1')
    #     :profile_id - ID (Honestly i do not know why Blizzard still needs this if
    #                   localized Battletag is unique enough)
    #     :name       - Just the name string in the Battle tag.
    #   Optional
    #     :locale     - (defaults to 'en_US')
    #     :api_key    - the api key
    #
    # Returns a Profile object with the following attributes
    #
    #      :profile_id, :realm, :display_name, :clan_name, :clan_tag,
    #      :achievement_points, :swarm_level, :terran_level, :zerg_level,
    #      :protoss_level, :acievement_points
    #
    # Example: If US account 'Playerone#1309' the profile can be accessible via
    # web from 'http://us.battle.net/sc2/en/profile/2143215/1/PlayerOne/'

    Bnet::Starcraft2::profile.find(region: 'us', profile_id: 2143215, name: 'PlayerOne')

## World of Warcraft

    # Query Battlenet API for the character profile
    #
    # Hash Params:
    #   Required
    #     :region          - (e.g. 'us', 'ea')
    #     :name            - String name of the toon
    #     :realm           - String name of the server the character is on (String)
    #   Optional
    #     :locale          - String locale (defaults to 'en_US')
    #     :api_key         - String api key
    #
    # Returns a Character with the following attributes
    #
    #   :name, :realm, :battlegroup, :class, :race, :gender, :level,
    #   :achievement_points, :total_honorable_kills, :calc_class
    #
    # Example : IF a character named 'AlexeiStukov' is on 'DragonMaw' 'US' server

    Bnet::WOW::Character.find(region: 'us', name: 'AlexeiStukov', realm: 'Dragonmaw')

### License


Licensed under the MIT license (see MIT-LICENSE file)
