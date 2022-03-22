public class GameState
{
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
    mainLogic.gameStateManager.SkiftGameState(name);
  }
}
