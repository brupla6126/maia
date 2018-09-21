module Artemisia
  # An Aspect is used by systems as a matcher against entities, to check if a system is
  # interested in an entity. Aspects define what sort of component types an entity must
  # possess, or not possess.
  #
  # This creates an aspect where an entity must possess A and B and C:
  # Aspect.new(all: %i[A B C])
  #
  # This creates an aspect where an entity must possess A and B and C, but
  # must not possess U or V.
  # Aspect.new(all: %i[A B C], exclude: %i[U V])
  #
  # This creates an aspect where an entity must possess A and B and C, but
  # must not possess U or V, but must possess one of X or Y or Z.
  # Aspect.new(all: %i[A B C], exclude: %i[U V], one: %i[X Y Z])
  class Aspect
    attr_reader :one, :all, :exclude

    def initialize(one: [], all: [], exclude: [])
      @one = (one || []).freeze
      @all = (all || []).freeze
      @exclude = (exclude || []).freeze
    end

    def empty?
      @all.empty? && @one.empty?
    end
  end
end
