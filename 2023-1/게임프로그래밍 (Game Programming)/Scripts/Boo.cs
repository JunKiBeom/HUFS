using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boo : MonoBehaviour
{
    [SerializeField]
    private float flapStrength;
    public Rigidbody2D mRigidBody;
    public Logic logic;
    public bool BoolIsActive = true;
    public float deadZone = -5;

    // Start is called before the first frame update
    void Start()
    {
        gameObject.name = "HUFS Bird";
        logic = GameObject.FindGameObjectWithTag("Logic").GetComponent<Logic>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && BoolIsActive) {
            mRigidBody.velocity = Vector2.up * flapStrength;
        }

        if (transform.position.y < deadZone) {
            logic.gameOver();
            BoolIsActive = false;
        }

    }

    private void OnCollisionEnter2D(Collision2D collisoin) 
    {
        logic.gameOver();
        BoolIsActive = false;
    }

}
