using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Logic : MonoBehaviour
{
    public int PlayerScore;
    public Text ScoreText;
    public AudioSource dingSFX;

    [ContextMenu("Increase Score")]
    public void addScore(int scoreToAdd) {
        PlayerScore = PlayerScore + scoreToAdd;
        ScoreText.text = PlayerScore.ToString();
        dingSFX.Play();
    }

    public void restartGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public GameObject gameOverScreen;

    public void gameOver()
    {
        gameOverScreen.SetActive(true);
    }
}
