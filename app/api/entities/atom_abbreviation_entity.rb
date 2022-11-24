# frozen_string_literal: true

class AtomAbbreviationEntity < Grape::Entity
  root false

  attributes :molfile, :name, :rtl_name, :aid, :bid

  def bid
    1
  end
end
