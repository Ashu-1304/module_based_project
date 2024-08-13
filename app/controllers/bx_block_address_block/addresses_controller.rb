require 'net/http'
require 'json'

class BxBlockAddressBlock::AddressesController < ApplicationController

  def all_record
    @records = BxBlockAddressBlock::Address.all
    if @records.present?
      render json:  BxBlockAddressBlock::AddressSerializer.new(@records).serialized_json,status: :ok
    else
      render json: {Error: "No Addresses Found?"},status: :not_found
    end
  end

  def fetch_location
    unless params[:pincode].present? && params[:country].present?
      render json: { errors: "Pincode and country are required" }, status: :unprocessable_entity
      return
    end
  
    pincode = params[:pincode]
    country = params[:country].downcase
  
    country_code = COUNTRY_CODES[country]
  
    if country_code.nil?
      render json: { error: "Unsupported country" }, status: :unprocessable_entity
      return
    end
    # debugger
    response = fetch_all_location(pincode, country_code)
  
    if response && response["places"]
      if response["places"].any?
        location_info = response["places"].first
        city = location_info["place name"]
        state = location_info["state"]
        longitude = location_info["longitude"]
        latitude = location_info["latitude"]
  
        @location = BxBlockAddressBlock::Address.new(
          place_name: city, 
          state: state, 
          longitude: longitude, 
          latitude: latitude
        )
        if @location.save
          render json: BxBlockAddressBlock::AddressSerializer.new(@location).serialized_json, status: :ok
        else
          render json: { error: @location.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      else
        render json: { error: "No Data Found?" }, status: :not_found
      end
    end
  end
  

  private

  COUNTRY_CODES = {
    'afghanistan' => 'af',
    'albania' => 'al',
    'algeria' => 'dz',
    'andorra' => 'ad',
    'angola' => 'ao',
    'antigua and barbuda' => 'ag',
    'argentina' => 'ar',
    'armenia' => 'am',
    'australia' => 'au',
    'austria' => 'at',
    'azerbaijan' => 'az',
    'bahamas' => 'bs',
    'bahrain' => 'bh',
    'bangladesh' => 'bd',
    'barbados' => 'bb',
    'belarus' => 'by',
    'belgium' => 'be',
    'belize' => 'bz',
    'benin' => 'bj',
    'bhutan' => 'bt',
    'bolivia' => 'bo',
    'bosnia and herzegovina' => 'ba',
    'botswana' => 'bw',
    'brazil' => 'br',
    'brunei' => 'bn',
    'bulgaria' => 'bg',
    'burkina faso' => 'bf',
    'burundi' => 'bi',
    'cabo verde' => 'cv',
    'cambodia' => 'kh',
    'cameroon' => 'cm',
    'canada' => 'ca',
    'central african republic' => 'cf',
    'chad' => 'td',
    'chile' => 'cl',
    'china' => 'cn',
    'colombia' => 'co',
    'comoros' => 'km',
    'congo' => 'cg',
    'congo (democratic republic of the)' => 'cd',
    'costa rica' => 'cr',
    'croatia' => 'hr',
    'cuba' => 'cu',
    'cyprus' => 'cy',
    'czechia' => 'cz',
    'denmark' => 'dk',
    'djibouti' => 'dj',
    'dominica' => 'dm',
    'dominican republic' => 'do',
    'ecuador' => 'ec',
    'egypt' => 'eg',
    'el salvador' => 'sv',
    'equatorial guinea' => 'gq',
    'eritrea' => 'er',
    'estonia' => 'ee',
    'eswatini' => 'sz',
    'ethiopia' => 'et',
    'fiji' => 'fj',
    'finland' => 'fi',
    'france' => 'fr',
    'gabon' => 'ga',
    'gambia' => 'gm',
    'georgia' => 'ge',
    'germany' => 'de',
    'ghana' => 'gh',
    'greece' => 'gr',
    'grenada' => 'gd',
    'guatemala' => 'gt',
    'guinea' => 'gn',
    'guinea-bissau' => 'gw',
    'guyana' => 'gy',
    'haiti' => 'ht',
    'honduras' => 'hn',
    'hungary' => 'hu',
    'iceland' => 'is',
    'india' => 'in',
    'indonesia' => 'id',
    'iran' => 'ir',
    'iraq' => 'iq',
    'ireland' => 'ie',
    'israel' => 'il',
    'italy' => 'it',
    'jamaica' => 'jm',
    'japan' => 'jp',
    'jordan' => 'jo',
    'kazakhstan' => 'kz',
    'kenya' => 'ke',
    'kiribati' => 'ki',
    'korea (north)' => 'kp',
    'korea (south)' => 'kr',
    'kosovo' => 'xk',
    'kuwait' => 'kw',
    'kyrgyzstan' => 'kg',
    'laos' => 'la',
    'latvia' => 'lv',
    'lebanon' => 'lb',
    'lesotho' => 'ls',
    'liberia' => 'lr',
    'libya' => 'ly',
    'liechtenstein' => 'li',
    'lithuania' => 'lt',
    'luxembourg' => 'lu',
    'madagascar' => 'mg',
    'malawi' => 'mw',
    'malaysia' => 'my',
    'maldives' => 'mv',
    'mali' => 'ml',
    'malta' => 'mt',
    'marshall islands' => 'mh',
    'mauritania' => 'mr',
    'mauritius' => 'mu',
    'mexico' => 'mx',
    'micronesia' => 'fm',
    'moldova' => 'md',
    'monaco' => 'mc',
    'mongolia' => 'mn',
    'montenegro' => 'me',
    'morocco' => 'ma',
    'mozambique' => 'mz',
    'myanmar' => 'mm',
    'namibia' => 'na',
    'nauru' => 'nr',
    'nepal' => 'np',
    'netherlands' => 'nl',
    'new zealand' => 'nz',
    'nicaragua' => 'ni',
    'niger' => 'ne',
    'nigeria' => 'ng',
    'north macedonia' => 'mk',
    'norway' => 'no',
    'oman' => 'om',
    'pakistan' => 'pk',
    'palau' => 'pw',
    'panama' => 'pa',
    'papua new guinea' => 'pg',
    'paraguay' => 'py',
    'peru' => 'pe',
    'philippines' => 'ph',
    'poland' => 'pl',
    'portugal' => 'pt',
    'qatar' => 'qa',
    'romania' => 'ro',
    'russia' => 'ru',
    'rwanda' => 'rw',
    'saint kitts and nevis' => 'kn',
    'saint lucia' => 'lc',
    'saint vincent and the grenadines' => 'vc',
    'samoa' => 'ws',
    'san marino' => 'sm',
    'sao tome and principe' => 'st',
    'saudi arabia' => 'sa',
    'senegal' => 'sn',
    'serbia' => 'rs',
    'seychelles' => 'sc',
    'sierra leone' => 'sl',
    'singapore' => 'sg',
    'slovakia' => 'sk',
    'slovenia' => 'si',
    'solomon islands' => 'sb',
    'somalia' => 'so',
    'south africa' => 'za',
    'south sudan' => 'ss',
    'spain' => 'es',
    'sri lanka' => 'lk',
    'sudan' => 'sd',
    'suriname' => 'sr',
    'sweden' => 'se',
    'switzerland' => 'ch',
    'syria' => 'sy',
    'taiwan' => 'tw',
    'tajikistan' => 'tj',
    'tanzania' => 'tz',
    'thailand' => 'th',
    'timor-leste' => 'tl',
    'togo' => 'tg',
    'tonga' => 'to',
    'trinidad and tobago' => 'tt',
    'tunisia' => 'tn',
    'turkmenistan' => 'tm',
    'tuvalu' => 'tv',
    'uganda' => 'ug',
    'ukraine' => 'ua',
    'united arab emirates' => 'ae',
    'united kingdom' => 'gb',
    'us' => 'us',
    'uruguay' => 'uy',
    'uzbekistan' => 'uz',
    'vanuatu' => 'vu',
    'vatican city' => 'va',
    'venezuela' => 've',
    'vietnam' => 'vn',
    'yemen' => 'ye',
    'zambia' => 'zm',
    'zimbabwe' => 'zw'
  }


  def fetch_all_location(pincode, country_code)
    uri = URI("https://api.zippopotam.us/#{country_code}/#{pincode}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue JSON::ParserError, Net::OpenTimeout => e
    Rails.logger.error("Error fetching location: #{e.message}")
    nil
  end
end
