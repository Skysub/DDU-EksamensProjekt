public class GameState
{
  //En gamestate klasse som alle skærme nedarver fra. Det sikrer os at alle skærme har disse metoder, som f.eks. Update()
  GameState(PApplet program, Keyboard kb) {
  }

  public void Update() {
  }

  public void Draw() {
  }

  public void Reset() {
  }

  void ChangeScreen(String name)
  {
    cursor(ARROW);
    mainLogic.gameStateManager.SkiftGameState(name);
  }

  void OnEnter() {
  }
}
