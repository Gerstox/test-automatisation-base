Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def urlBase = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def apiCharacters = '/api/characters'
    * def user = 'testuser'
    * def updateCharacterId = '1'
    * def notExistsId = '9999'

  Scenario: Verificar que un endpoint público responde 200
    Given url 'https://httpbin.org/get'
    When method get
    Then status 200

  @Practica
  Scenario: Obtener todos los personajes
    Given url urlBase + '/' + user + apiCharacters
    When method get
    Then status 200
    And print response
    #And match response.count == 82

  @Practica
  Scenario: Crear personaje
    Given url urlBase + '/' + user + apiCharacters
    And request {"name": "Iron Man","alterego": "Tony Stark","description": "Genius billionaire","powers": ["Armor", "Flight"]}
    When method post
    Then status 201
    And print response

  @Practica
  Scenario: Crear personaje con nombre duplicado
    Given url urlBase + '/' + user + apiCharacters
    And request {"name": "Iron Man","alterego": "Otro","description": "Otro","powers": ["Armor"]}
    When method post
    Then status 400
    And print response
    * def error = response.error
    And print error
    And match error == 'Character name already exists'

  @Practica
  Scenario: Crear personaje, faltan campos requeridos
    Given url urlBase + '/' + user + apiCharacters
    And request {"name": "","alterego": "","description": "","powers": []}
    When method post
    Then status 400
    And print response

  @Practica
  Scenario: Actualizar personaje
    Given url urlBase + '/' + user + apiCharacters + '/' + updateCharacterId
    And request {"name": "Iron Man","alterego": "Tony Stark","description": "Updated description","powers": ["Armor","Flight"]}
    When method put
    Then status 200
    And print response

  @Practica
  Scenario: Actualizar personaje que no existe
    Given url urlBase + '/' + user + apiCharacters + '/' + notExistsId
    And request {"name": "Iron Man","alterego": "Tony Stark","description": "Updated description","powers": ["Armor","Flight"]}
    When method put
    Then status 404
    And print response
    * def error = response.error
    And print error
    And match error == 'Character not found'

  @Practica
  Scenario: Obtener personaje por ID
    Given url urlBase + '/' + user + apiCharacters + '/' + updateCharacterId
    When method get
    Then status 200
    And request {"name": "Iron Man","alterego": "Tony Stark","description": "Updated description","powers": ["Armor","Flight"]}
    And print response
    * def alterego = response.alterego
    And print alterego
    And match alterego == 'Tony Stark'

  @Practica
  Scenario: Obtener personaje por ID que no existe
    Given url urlBase + '/' + user + apiCharacters + '/' + notExistsId
    When method get
    Then status 404
    And print response
    * def error = response.error
    And print error
    And match error == 'Character not found'

  @Practica
  Scenario: Eliminar personaje por ID
    Given url urlBase + '/' + user + apiCharacters + '/' + updateCharacterId
    When method delete
    Then status 204
    And print response

  @Practica
  Scenario: Eliminar personaje por ID que no existe
    Given url urlBase + '/' + user + apiCharacters + '/' + notExistsId
    When method delete
    Then status 404
    And print response
    * def error = response.error
    And print error
    And match error == 'Character not found'