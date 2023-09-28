# TextParser

    This project has been completed for demonstration purposes and requires modification for use in production. 

    The chosen architecture is a modified VIP architecture. Some presenters have been omitted to save time due to the limited amount of presentation logic. A router has been added, and dependencies between components have been changed (resembling a combination of VIPER and partially MVVM).

    The ModuleAssembler serves as a factory for modules and is responsible for dependency injection. The 'services' field should store services that depend on the application's state, providing a basic demonstration of the application's extensibility.

    The project includes many simplifications, such as screens being designed with maximum simplicity (static tables, UITableViewController instead of UIViewController + UITableView), no loading indicators, and no added application resource managers (e.g., RSwift or similar). Lack of service error handling in views.
    
    If time permits, the following would be desirable to implement: 
    - Multi-modularity based on Swift Package Manager (SPM)
    - Use xCodeGen for progject configuration
    - Create templates for elements of Scene Module
    - Cover all business logic by UnitTests 
    - Presenters
