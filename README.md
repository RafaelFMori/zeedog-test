# Details

- system dependencies(Ruby 2.6.3, Rails 5.2.3, Git)
- No especial configuration is required
- No rakes or independent services were added

# Setup

- Clone this repository to your machine using a git interface
- On your terminal go to your new zeedog-test directory.
- run "bundle install" or "bundle" to install dependencies.
- run "rake db:migrate" on your terminal to create the database and the score table.
- run "rails s" or "puma" to start the webserver.
- Now you are good to go, see the endpoints session for more information about
  the features this application can deliver.

- to run tests: "rspec spec" or just "rspec"(shipped with simplecov)
  OBS: This application local setup was not tested on Windows or MacOS environments

# Endpoints and Parameters

  ### Search
  **-api/v1/repositories/search(GET) - responsible for complex repos search**

  **accepted params:**
  **language** - string - *
  **username** - string - *
  **label** - string - *
  **page** - integer - optional(default to 1)
  **per_page** - integer - optional(default to 30 - maximum 100)
  **sort** - string - optional(possible values: forks, stars)
  **order** - string - optional(possible values: asc, desc)
  * at least one of these parameters must be present
    (reasoning on the considerations session of this document)

  **Endpoint URL example:** localhost:3000/api/v1/repositories/search?language=ruby&username=Jekyll&label=ruby&page=1&per_page=30&sort=stars&order=desc

  **specifics:**
  - Language, username and label can be used together or separated using them
   together will take every one of the values into consideration to make the search.

  - Because of github API limitations only sorted searchs can be ordered
   source: https://developer.github.com/v3/search/#search-repositories

  - Label will perform a text search on repositories readme, name and description
  
  ### List
  **-api/v1/repositories/list(GET) - responsible for listing public and private repos**

  **accepted params:**
  **type** - string - optional(default to 'public')
  **page** - integer - optional(default to 1)
  **per_page** - integer - optional(default to 30)

  **Endpoint URL example:** localhost:3000/api/v1/repositories/list?type=private&page=1&per_page=5

  **specifics:**
   - This endpoint can be called with no parameter in which case it will answer
    with a list of public repositories(paginated by default - see accepted params)
    
   - Calling the endpoint passing type 'private' will incur on a not found message, since
    it will only works with github authenticated requests, being this project a test
    I opted for leaving this implementation untouched(note that you would only have to
    delete the delete option on the TYPE_VALUES constant on list controller and
    delete/comment the related tests for it to search only for public results).

  **-api/v1/authentication/authenticate(POST) - responsible for authenticating a user(JWT)**

  **accepted params:**
  **email** - string - required
  **password** - string - required

  **Endpoint URL example:** localhost:3000/api/v1/authentications/authenticate
  **params:** email=jhondoe@gmail.com, password=swordfish(digested)


# Considerations

### "required optional" parameters on SearchContract.

   Although I could clearly see this parameters as one required param
   I faced some problems that made me go with the approach of making
   a complex rule for them

   Firstly I could have passed them as a string in a search fashion
   separated by "+" something like:

   localhost:3000/api/v1/repositories/search?search_elements=language:ruby+user:jekyll

   and on search_operation:

   contract[:search_elements].split(' ') ~ since + become an empty space
   the result os this line of code would be something like:
   ["language:ruby", "user:jekyll"] that are good to go "q" options for github

   I would have to search for a string to know if language is blank what is
   extremely error prone specially if other element and "language" written in them
   say: label:language_watcher for example

   With a approach like this:

   params do
    required(:search_elements).hash do
      optional(:language)...
    end

  I have the data coercion problem, since rails will not evaluate the hash like string
  getting it and transforming it on a hash is error prone and slow, also contract
  would not been the right place to do this and I think operation is not either.

  On this case I would talk with the team, explain my points of view so we could
  decide how we would address this problems on the present and future


### ApplicationController params

  Since dry-validation doesn't accept rails params to use, and later the code
  would not accept unpermitted params, I created this little method to accept and parse
  the params, to be clear I'm not kin with this approach for it's automagical attributes
  but on this case I don't think is a problem.

### Validate_contract method

  Since all operations are using the same implementation I decided to extract it
  into the Operation class.

  I sense that validate the contract is something that should be done on the controller
  layer, it creates a injection that only serves this purpose(has no real use inside the operation)

  I have done some fast experiments, using the application controller and before_action
  but as exposed earlier in this document I don't like this approach and although I successfully had
  validated it on the "right place", I divided the exception handling and created an
  obscure function.

  the duplication on the 400 is not the best idea either, but it made easier to read

### Default values

  I opted for creating and enforcing default values for parameters on the operation layer
  but I'm not entirely sure that this is the best approach, I don't feel that the Contract
  layer is the best option too.

### Message class

  Message serves the utility of managing application messages, on this test
  I have used it mostly to manage messages that were used more than once.

### Concepts
  As it is now it's just gathering a collection of classes that do not have a concrete dir
  to be (on app dir because of the autoload) I thought of calling it libs, entities and etc...
  but none of this names exemplified whats I wanted, for the time being this will be the name of this directory.

### Separation of List and Search Endpoints

  Even though both of this endpoints utilize the same github API mechanism(repo search)
  I choose to separate them for some reasons, being them:

   - I understand that list is a separated feature that already have a simpler implementation
   that could take a different path on its business logic.

   - Git hub api sets a limit to how many characters a search can have and how many parameters
   it can concatenate, being the search endpoint an complex endpoint with many possibilities
   of parameters and free text search, I fear that this limit would be broken eventually with this
   limitations - source: https://developer.github.com/v3/search/#search-repositories

   - Spec hell

### ONGOING

  Finish JWT authentication implementation
  Mock github requests on tests

  **maybe:**

  usage of a json serializer
  stop using the few factories present in this project
  swapping them for fixtures
