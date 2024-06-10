// using Fusion;
using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.Windows;

public class CapsulePlayerController : NetworkBehaviour
{


    // [SerializeField] CinemachineVirtualCamera tppVirtualCamera;
    [SerializeField] Rigidbody rb;
    [SerializeField] float speed;
    [SerializeField] LayerMask layerMask;


    private readonly List<LagCompensatedHit> hits = new List<LagCompensatedHit>();
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
        DetectObstacles();
        if (GetInput(out InputStorage inputStorageOut))
        {
            Vector3 direction = (transform.forward * inputStorageOut.move.y + transform.right * inputStorageOut.move.x) * Runner.DeltaTime * speed;
            direction += transform.position;
            rb.MovePosition(direction);
            // Debug.Log($"{nameof(CapsulePlayerController)} \t move  {inputStorageOut.move}");
        }
        
        
    }
    #endregion


    void DetectObstacles()
    {
        // Runner.LagCompensation.OverlapBox(Vector3.zero, new Vector3(), transform.rotation, player : Object.HasInputAuthority, hits, layerMask, HitOptions.SubtickAccuracy, true);
        int hitOut = Runner.LagCompensation.OverlapSphere(transform.position, 0.88f, player: Object.InputAuthority, hits, options: HitOptions.SubtickAccuracy);
        foreach(var hit in hits)
        {
            // hit.GameObject.layer == layerMask.value;
            Debug.Log($"Hit layer {hit.GameObject.layer}");
        }
        
    }
}
