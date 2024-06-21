using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraHandler : MonoBehaviour
{

    [SerializeField] private Transform player;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void FixedUpdate()
    {
        if (player == null) 
            return;

        var xClampPosition = Mathf.Clamp(transform.position.x, -14, 14);
        transform.position = new Vector3(player.position.x, 4, 0);

    }

   
    public void SetPlayer(Transform player)
    {
        this.player = player;
    }
}
