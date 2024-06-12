// using Fusion;
using Cinemachine;
using Fusion;
using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.Windows;

public class CapsulePlayerController : CharacterControlManager
{

    [SerializeField] Rigidbody rb;
    [SerializeField] float speed;
    [SerializeField] bool _jumping;

    [SerializeField] LayerMask layerMask;
    [SerializeField] HitboxRoot hitboxRoot;

    private readonly List<LagCompensatedHit> hits = new List<LagCompensatedHit>();
    bool _cameraAssignedToPlayer;
    GameSceneManager _gameSceneManager;

    public CinemachineVirtualCamera _tppVirtualCamera;
    public Transform _mainCamera;

    



    #region Monobehaviour callbacks

    private void Awake()
    {
        _gameSceneManager = new GameSceneManager();
    }

    void Start()
    {
        // _gameSceneManager.AddPlayersToDictionary(Object.Id.ToString(), transform);
        // _gameSceneManager.AddPlayerNetworkObjectIdToArrayList(Object.Id.ToString());
        Debug.Log($"Object Id {Object.Id.ToString()}");
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
            Move(inputStorageOut);  
            Jump(inputStorageOut);
        }
    }
    #endregion

    #region Base class methods
    public override void Move(InputStorage inputStorageOut)
    {
        Vector3 direction = (transform.forward * inputStorageOut.Move.y + transform.right * inputStorageOut.Move.x) * Runner.DeltaTime * speed;
        direction += transform.position;
        // direction.Normalize();
        rb.MovePosition(direction);

        transform.rotation = Quaternion.Slerp(Quaternion.Euler(0, transform.eulerAngles.y, 0),
                                                Quaternion.Euler(0, inputStorageOut.CameraYrotation, 0),
                                                Runner.DeltaTime * 30f);
    }

    public override void Jump(InputStorage inputStorageOut)
    {
        if (inputStorageOut.PlayerButtons.IsSet(PlayerInputButtons.Jump) && !_jumping)
        {
            
            rb.AddForce(transform.up * 3f, ForceMode.VelocityChange);
            _jumping = true;
            
            Invoke(nameof(ResetJumping), 1f);
            Debug.Log($"Jump is pressed.");
        }
            
    }
    #endregion

    #region Private methods
    void ResetJumping()
    {
        _jumping = false;
        Debug.Log(nameof(ResetJumping));
    }
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
        // Destroy(this.gameObject);
        _gameSceneManager.RemovePlayersFromDictionary(Object.Id.ToString());
        Runner.Shutdown();
        Debug.Log($"{nameof(CapsulePlayerController)} \t {nameof(DestroyPlayerOnLeft)}");
    }
    #endregion
}
