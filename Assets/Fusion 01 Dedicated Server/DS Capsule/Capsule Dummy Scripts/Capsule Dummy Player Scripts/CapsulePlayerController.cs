// using Fusion;
using Cinemachine;
using Fusion;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CapsulePlayerController : CharacterControlManager
{

    public delegate void CapsulePlayerControllerDelegate(int index);
    public CapsulePlayerControllerDelegate OnCapsulePlayerChanged;


    #region Serialize private fields
    [SerializeField] Rigidbody rb;
    [SerializeField] float moveSpeed;
    [SerializeField] float rotationSpeed = 30f;
    [SerializeField] bool jumping = false;
    [SerializeField] float jumpHeight = 0.25f;
    [SerializeField] bool onGround = false;
    [SerializeField] float rayLength = 1f;
    [SerializeField] LayerMask layerMask;
    [SerializeField] Transform weapon2Position;
    #endregion

    #region Private fields
    readonly List<LagCompensatedHit> _hits = new List<LagCompensatedHit>();
    bool _cameraAssignedToPlayer;
    
    GameSceneManager _gameSceneManager;
    #endregion


    #region Public fields
    public NetworkRunner _networkRunner { get; private set; }
    public CinemachineVirtualCamera _tppVirtualCamera;
    public Transform _mainCamera;
    // public bool rayHit;
    public LagCompensatedHit lagCompensatedHit;
    
    //=========================================
    public float lagCompensatedHitDistance;
    public float runnerTick;
    /*[Networked] public float initialTick => default;
    [Networked] public float targetTick => default;*/
    //=========================================


    #endregion

    [Networked] TickTimer timer { get; set; }

    #region Monobehaviour callbacks

    private void Awake()
    {
        
        _gameSceneManager = new GameSceneManager();
    }

    void Start()
    {
        
    }

    private void OnEnable()
    {
        // _networkRunner = Runner;
        /*UiHandler.OnUiHandler -= DestroyPlayerOnLeft;
        UiHandler.OnUiHandler += DestroyPlayerOnLeft;*/
        Debug.Log($"<color=green>{nameof(CapsulePlayerController)} \t </color>");
    }

    private void OnDisable()
    {
        
        
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        jumping = false;
    }

    private void OnCollisionStay(Collision collision)
    {

       
    }

    private void OnCollisionExit(Collision collision)
    {

    }

    private void Update()
    {
        // Debug.DrawLine(transform.position, -transform.up * 1, Color.red);
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
        /*if (!_cameraAssignedToPlayer && Object.HasInputAuthority)
        {
            CameraHandler cameraHandler = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<CameraHandler>();
            cameraHandler.SetPlayer(transform);
            _cameraAssignedToPlayer = true;
        }*/

    }


    public override void FixedUpdateNetwork()
    {
        if (GetInput(out InputStorage inputStorageOut))
        {
            Move(inputStorageOut);  
            Jump(inputStorageOut);
            Logout(inputStorageOut);
        }
        DetectGround();

        runnerTick = Runner.Tick;
        if (timer.Expired(Runner))
        {
            timer = TickTimer.None;
            Debug.Log("Timer Expired");
        }
    }

    
    #endregion

    #region Base class methods
    public override void Move(InputStorage inputStorageOut)
    {
        Vector3 direction = (transform.forward * inputStorageOut.Move.y + transform.right * inputStorageOut.Move.x) * Runner.DeltaTime * moveSpeed;

       /* if (inputStorageOut.Move.x > 0)
        {
            transform.rotation = Quaternion.Euler(0, 90, 0);
            

        }
        else if( < 0)
        {

            transform.rotation = Quaternion.Euler(0, -90, 0);
        }*/
        // Vector3 direction = (transform.forward * inputStorageOut.Move.y) * Runner.DeltaTime * moveSpeed;
        direction += transform.position;

        rb.MovePosition(direction);

        transform.rotation = Quaternion.Slerp(Quaternion.Euler(0, transform.eulerAngles.y, 0),
                                                Quaternion.Euler(0, inputStorageOut.CameraYrotation, 0),
                                                Runner.DeltaTime * rotationSpeed);
    }

    public override void Jump(InputStorage inputStorageOut)
    {
        if (inputStorageOut.PlayerButtons.IsSet(PlayerInputButtons.Jump) && !jumping)
        {
            
            rb.AddForce(transform.up * jumpHeight, ForceMode.VelocityChange);
            jumping = true;
            Debug.Log($"Jump is pressed.");
        } 
    }

    private void Logout(InputStorage inputStorageOut)
    {
        if (inputStorageOut.PlayerButtons.IsSet(PlayerInputButtons.Logout))
        {
            // Check if this instance of the player controller belongs to the local player
            if (Object.HasInputAuthority)
            {
                // Shutdown the runner (assuming Runner.Shutdown() is specific to the local player)
                Runner.Shutdown();

                // Load a new scene (assuming SceneManager.LoadSceneAsync(1) should affect only the local player)
                SceneManager.LoadSceneAsync(1);

                Debug.Log($"<color=red>Player got shut down</color>");
            }
        }
    }
    #endregion

    #region Private methods
    void ResetJumping()
    {
        jumping = false;
        Debug.Log(nameof(ResetJumping));
    }

    void DetectGround()
    {
        // rayHit = Runner.LagCompensation.Raycast(transform.position, -transform.up, rayLength, player: Object.InputAuthority, out var hit, layerMask, HitOptions.SubtickAccuracy);
        // lagCompensatedHit = hit;
        // lagCompensatedHitDistance = hit.Distance;
    }

    void DetectObstacles()
    {
        // Clear the hits list before each check
        _hits.Clear();

        // Perform lag-compensated sphere overlap query
        int hitCount = Runner.LagCompensation.OverlapSphere(transform.position, 1.1f, Object.InputAuthority, _hits, layerMask, HitOptions.SubtickAccuracy);

        // Check if any of the hits belong to the ground layer
        foreach (var hit in _hits)
        {
            Debug.Log(hit.GameObject.name);
            if (hit.GameObject.layer == LayerMask.NameToLayer("Ground"))
            {
                Debug.Log("Player is grounded.");
                return;
            }
        }

    }

    /*void DestroyPlayerOnLeft()
    {
        if (!Object.HasInputAuthority)
            return;
        Runner.Shutdown();
        Debug.Log($"{nameof(CapsulePlayerController)} \t {nameof(DestroyPlayerOnLeft)}");
    }*/
    #endregion

    #region public methods
    public void CollectWeapon()
    {

    }
    #endregion
}
