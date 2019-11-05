REPOSITORIES = [
  GameRepository,
  WaitingRoomRepository
].freeze

class RepositoryRegisterer
  def initialize(repositories)
    @repositories = repositories.reduce({}) do |acc, curr|
      acc[curr.name] = curr.new
      acc
    end
  end

  def get(class_name)
    repository = @repositories[class_name]
    raise "Repository not found #{class_name}" if repository.nil?

    repository
  end
end

Repositories = RepositoryRegisterer.new(REPOSITORIES)