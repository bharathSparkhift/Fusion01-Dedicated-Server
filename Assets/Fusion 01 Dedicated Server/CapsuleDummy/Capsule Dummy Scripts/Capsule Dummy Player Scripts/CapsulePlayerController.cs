// using Fusion;
using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CapsulePlayerController : NetworkBehaviour
{


    // [SerializeField] CinemachineVirtualCamera tppVirtualCamera;
    [SerializeField] Rigidbody rb;
    [SerializeField] float speed;


    bool _cameraAssignedToPlayer;


    #region Monobehaviour callbacks
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    #endregion

    #region NetworkRunnercallbacks
    public override void Render()
    {
        if (!_cameraAssignedToPlayer)
        {
            /*tppVirtualCamera = GameObject.FindGameObjectWithTag("TPP Camera").GetComponent<CinemachineVirtualCamera>();
            tppVirtualCamera.Follow = this.transform;*/
            _cameraAssignedToPlayer = true;
        }
        
    }


    public override void FixedUpdateNetwork()
    {
        // Fetch the details form the INetworkInput.
        /*if (GetInput(out PlayerInputStruct input_)) 
        {
            // _animMoveValue = input_.JoystickVec2;

            if (input_.MoveDirection != Vector2.zero)
            {
                Vector3 direction = (transform.forward * input_.MoveDirection.y + transform.right * input_.MoveDirection.x) * 0.11f;
                // direction = transform.position + (transform.forward * 0.2f);
                direction += transform.position;
                rb.Move(direction, Quaternion.Euler(0,270f,0));

            }

            // Player rotation accordance with the Main camera rotation.
            *//*transform.rotation = Quaternion.Slerp(Quaternion.Euler(0, transform.eulerAngles.y - 90f, 0),
                                                    Quaternion.Euler(0, input_.CameraYrotation, 0),
                                                    Runner.DeltaTime * 10);*//*


        }*/
    }
    #endregion
}
