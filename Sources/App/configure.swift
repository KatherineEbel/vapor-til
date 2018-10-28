import FluentPostgreSQL
import Vapor

public func configure(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
) throws {
  try services.register(FluentPostgreSQLProvider())
  let router = EngineRouter.default()
  try routes(router)
  services.register(router, as: Router.self)

  var middlewares = MiddlewareConfig()
  middlewares.use(ErrorMiddleware.self)
  services.register(middlewares)

  // configure a database
  let databaseName: String
  let portNumber: Int
  if env == .testing {
    databaseName = "vapor-test"
    portNumber = 5433
  } else {
    databaseName = "vapor"
    portNumber = 5432
  }
  var databases = DatabasesConfig()
  let databaseConfig = PostgreSQLDatabaseConfig(
    hostname: "localhost",
    port: portNumber,
    username: "vapor",
    database: databaseName,
    password: "vapor"
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
}
