# TextParser

	This project has been completed for demonstration purposes and requires modification for use in production. 

	The chosen architecture is a modified VIP architecture. Presenters have been omitted to save time due to the limited amount of presentation logic. A router has been added, and dependencies between components have been changed (resembling a combination of VIPER and partially MVVM).

	The ModuleAssembler serves as a factory for modules and is responsible for dependency injection. The 'services' field should store services that depend on the application's state, providing a basic demonstration of the application's extensibility.

	The TextProviding protocol is marked as 'async' to allow changing the data source to asynchronous without making changes to the View layer. 

	The project includes many simplifications, such as screens being designed with maximum simplicity (static tables, UITableViewController instead of UIViewController + UITableView), no loading indicators, no localization, and no added application resource managers (e.g., RSwift or similar). Lack of error handling in services and networking layer. Assumption of using force unwraps in non critical places. The networking layer is based on Alamofire, but in a real project, URLSession and something similar to URLRequestConvertible would be preferred.

	If time permits, the following would be desirable to implement: 
	- Multi-modularity based on Swift Package Manager (SPM)
	- Use xCodeGen for progject configuration
	- Create templates for elements of Scene Module
	- UnitTests 
	- Presenters
	- Stricter control over the logic of interactors, and better separation of business logic from UI modules.