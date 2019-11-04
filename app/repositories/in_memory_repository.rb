class InMemoryRepository
  def initialize
    @by_id = {}
  end

  def load(id)
    entity = @by_id[id]
    raise EntityNotFound, "Entity #{id} not found" if entity.nil?

    entity
  end

  def add(entity)
    @by_id[entity.id] = entity
  end

  def delete(id)
    @by_id.delete(id)
  end
end