import FluentPostgreSQL
import Vapor
import Leaf

public func configure(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
) throws {
  try services.register(FluentPostgreSQLProvider())
  try services.register(LeafProvider())
  let router = EngineRouter.default()
  try routes(router)
  services.register(router, as: Router.self)

  var middlewares = MiddlewareConfig()
  middlewares.use(ErrorMiddleware.self)
  middlewares.use(FileMiddleware.self)
  services.register(middlewares)

  // configure a database
  let databaseName: String
  if env == .testing {
    databaseName = "vapor-test"
  } else {
    databaseName = "vapor"
  }
  var databases = DatabasesConfig()
  let databaseConfig = PostgreSQLDatabaseConfig(
    hostname: "localhost",
    username: "vapor",
    database: databaseName
  )

  let database = PostgreSQLDatabase(config: databaseConfig)
  databases.add(database: database, as: .psql)
  services.register(database)
  


  var migrations = MigrationConfig()
  migrations.add(model: User.self, database: .psql)
  migrations.add(model: Acronym.self, database: .psql)
  migrations.add(model: Category.self, database: .psql)
  migrations.add(model: AcronymCategoryPivot.self, database: .psql)
  services.register(migrations)
  
  var commandConfig = CommandConfig.default()
  commandConfig.useFluentCommands()
  services.register(commandConfig)
  
  config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}
