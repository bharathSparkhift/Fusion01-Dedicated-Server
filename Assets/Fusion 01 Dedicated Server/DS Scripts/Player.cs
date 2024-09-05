using Fusion;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;


/// <summary>
/// Player
/// </summary>
public class Player : NetworkBehaviour
{


    [SerializeField] Rigidbody rigidBody;
    [SerializeField] Animator animator;
    [SerializeField] float speed = 5f;
    [SerializeField] float rotationSpeed = 5f;

    [SerializeField] Transform mainCamera;
    [SerializeField] float rotationOffset = 180f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(mainCamera == null)
        {
            mainCamera = FindObjectOfType<Camera>().transform;
        }
    }

    public override void Spawned()
    {
        Cinemachine_Handler.Instance.Update_Follow(transform);
        Debug.Log($"<color=green>{nameof(Player)} \t {nameof(Spawned)}</color>");
    }

    [Networked]  public  Vector2 direction_Anim { get; set; }
    [Networked] public float x_Anim { get; set; }
    [Networked] public float y_Anim { get; set; }
    public override void Render()
    {
        animator.SetFloat("horizontal", x_Anim);
        animator.SetFloat("vertical", y_Anim);
        //Debug.Log($"{nameof(Render)} \t Direction anim {x_Anim} : {y_Anim}");
    }

    void Handle_Animations(Vector2 direction)
    {
        
    }

    public override void FixedUpdateNetwork()
    {
        // Debug.Log($"Object has state authority : {Object.HasStateAuthority}");
        if (Object.HasStateAuthority)
        {
            Receive_Inputs();
            
        }
        
    }

    void Receive_Inputs()
    {
        
        if(GetInput(out Server_Input_Struct server_Input_Struct))
        {
            Vector3 direction = transform.right * server_Input_Struct.direction.x + transform.forward * server_Input_Struct.direction.z;
            // Debug.Log($"Direction {direction}");
            rigidBody.MovePosition(transform.position + direction * Runner.DeltaTime * speed);
            direction_Anim = server_Input_Struct.direction;
            x_Anim = server_Input_Struct.direction.x;
            y_Anim = server_Input_Struct.direction.z;
            
            if(mainCamera != null) 
                transform.rotation = Quaternion.Euler(0, mainCamera.transform.rotation.eulerAngles.y, 0);


            /*if (server_Input_Struct.rotation == 1)
            {
                // transform.rotation = Quaternion.Slerp(Quaternion.Euler(0, 0, 0), 
                transform.Rotate(new Vector3(0, rotationSpeed * Runner.DeltaTime, 0));
            }

            // transform.rotation = Quaternion.Slerp(Quaternion.Euler(0, transform.rotation.y, 0), mainCamera.rotation, Runner.DeltaTime * rotationSpeed);
            *//*transform.LookAt(mainCamera.position);  
            transform.rotation = Quaternion.Euler(0,transform.rotation.y - rotationOffset ,0);*//*

            // Get the camera's forward direction
            Vector3 cameraForward = mainCamera.forward;

            // Calculate the direction opposite to the camera's forward
            Vector3 oppositeDirection = -cameraForward;

            // Make the player look in the opposite direction of the camera
            // Ignore the Y axis to avoid tilting (only rotate on the horizontal plane)
            oppositeDirection.y = rotationOffset;

            if (oppositeDirection != Vector3.zero)
            {
                // Rotate the player to face the opposite direction
                // transform.rotation = Quaternion.LookRotation(oppositeDirection);
                // transform.LookAt(mainCamera.forward);
                // transform.rotation = Quaternion.Euler(0, mainCamera.transform.rotation.eulerAngles.y, 0);
            }*/

            //Debug.Log($"{nameof(Receive_Inputs)} \t Direction {direction} \t Player is moving with the help of rigidbody");
        }
        else
        {
            direction_Anim = Vector2.zero;
            //Debug.Log("<color=red>No inputs are receving..</color>");
        }
        
    }

    
}
