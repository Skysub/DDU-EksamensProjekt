public static class GameStateManager

{
  GameState currentGameState;
  HashMap<String, GameState> gameStates;  

  //GameStateManageren sørger for at holde styr på hvilken skærm der er aktiv
  GameStateManager() {
    currentGameState = null;
    gameStates = new HashMap<String, GameState>();
  }

  //Opdaterer den aktive gamestate
  void Update()
  {
    if (currentGameState != null)
      currentGameState.Update();
  }

  //tegner den aktive gamestate
  void Draw()
  {
    if (currentGameState != null)
      currentGameState.Draw();
  }

  //Tilføjer en gameState til listen
  public void AddGameState(String name, GameState state)
  {
    gameStates.put(name, state);   // gamestat tilføjes via string som Key, hvor state er værdien
  }

  //Ændrer hvilken gamestate der er aktiv
  public void SkiftGameState(String name) {
    if (currentGameState != null) currentGameState.Reset();
    if (gameStates.containsKey(name))
    {
      currentGameState = gameStates.get(name);
      currentGameState.OnEnter();
    } else {
      println("'"+name+"' er ikke en gyldig gameState");
    }
  }

  public void Reset()
  {
    if (currentGameState != null)
      currentGameState.Reset();
  }

  //Skaffer selve gameStaten
  public GameState GetGameState(String name)
  {
    if (gameStates.containsKey(name))
      return gameStates.get(name);
    return null;
  }

  //Skaffer navnet på den aktive gamestate
  public String GetCurrentGameStateName() {
    java.util.Set<String> kSet = gameStates.keySet();
    for (String x : kSet) {
      if ( GetGameState(x) == currentGameState ) {
        return x;
      }
    }
    return "";
  }
}
