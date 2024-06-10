// using Fusion;
using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Windows;

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

        if (GetInput(out InputStorage inputStorageOut))
        {
            Vector3 direction = (transform.forward * inputStorageOut.move.y + transform.right * inputStorageOut.move.x) * Runner.DeltaTime * speed;
            direction += transform.position;
            rb.MovePosition(direction);
            // Debug.Log($"{nameof(CapsulePlayerController)} \t move  {inputStorageOut.move}");
        }
        
    }
    #endregion
}
