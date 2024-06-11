// using Fusion;
using Cinemachine;
using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.Windows;

public class CapsulePlayerController : NetworkBehaviour
{

    [SerializeField] Rigidbody rb;
    [SerializeField] float speed;

    [SerializeField] LayerMask layerMask;
    [SerializeField] HitboxRoot hitboxRoot;

    private readonly List<LagCompensatedHit> hits = new List<LagCompensatedHit>();
    bool _cameraAssignedToPlayer;

    public CinemachineVirtualCamera _tppVirtualCamera;
    public Transform _mainCamera;


    #region Monobehaviour callbacks
    void Start()
    {
        
    }

    private void OnEnable()
    {
        UiHandler.OnUiHandler += DestroyPlayerOnLeft;
    }

    private void OnDisable()
    {
        UiHandler.OnUiHandler -= DestroyPlayerOnLeft;
    }

    #endregion

    #region NetworkRunnercallbacks
    public override void Render()
    {
        if (!_cameraAssignedToPlayer && Object.HasInputAuthority)
        {
            _tppVirtualCamera = GameObject.FindGameObjectWithTag("TPP Camera").GetComponent<CinemachineVirtualCamera>();
            _tppVirtualCamera.Follow = this.transform;
            _mainCamera = Camera.main.transform;
            FirstPersonCamera.Instance.Target = this.transform;

            Debug.Log("Camera assigned to player.........");
            _cameraAssignedToPlayer = true;
        }

    }


    public override void FixedUpdateNetwork()
    {
        // DetectObstacles();
        if (GetInput(out InputStorage inputStorageOut))
        {
            Vector3 direction = (transform.forward * inputStorageOut.Move.y + transform.right * inputStorageOut.Move.x) * Runner.DeltaTime * speed;
            direction += transform.position;
            rb.MovePosition(direction);

            transform.rotation = Quaternion.Slerp(Quaternion.Euler(0, transform.eulerAngles.y, 0),
                                                    Quaternion.Euler(0, inputStorageOut.CameraYrotation, 0),
                                                    Runner.DeltaTime * 30f);
        }
    }
    #endregion


    void DetectObstacles()
    {
        // Clear the hits list before each check
        hits.Clear();

        // Perform lag-compensated sphere overlap query
        int hitCount = Runner.LagCompensation.OverlapSphere(transform.position, 1.1f, Object.InputAuthority, hits, layerMask, HitOptions.SubtickAccuracy);

        // Check if any of the hits belong to the ground layer
        foreach (var hit in hits)
        {
            Debug.Log(hit.GameObject.name);
            if (hit.GameObject.layer == LayerMask.NameToLayer("Ground"))
            {
                Debug.Log("Player is grounded.");
                return;
            }
        }

    }

    void DestroyPlayerOnLeft()
    {
        Destroy(this.gameObject);
        Debug.Log($"{nameof(CapsulePlayerController)} \t {nameof(DestroyPlayerOnLeft)}");
    } 
}
