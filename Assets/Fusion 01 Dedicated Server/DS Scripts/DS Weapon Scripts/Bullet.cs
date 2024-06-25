using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : NetworkBehaviour
{

    #region Serialize private fields
    
    [SerializeField] private float forwardForce = 10f;
    [SerializeField] private float _lifeTime = 5f;
    [SerializeField] private Vector3 _localPosition = new Vector3(0.001f, 0.133f, 0.916f);
    [field:SerializeField] 
    NetworkBool _tickTimerStarted { get; set; }
    bool _bulletFired;
    
    
    #endregion

    #region Networked properties.
    [Networked] private TickTimer _lifeCoolDown {  get; set; }

    #endregion

    #region Monobehaviour callbacks
    private void Awake()
    {
        
    }
    // Start is called before the first frame update
    void Start()
    {

    }

    private void OnEnable()
    {
        // transform.localPosition = _localPosition;
        FireBullet();
    }


    private void OnCollisionEnter(Collision collision)
    {
        Debug.Log($"{nameof(OnCollisionEnter)} \t {collision.gameObject.name}");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    #endregion

    public void FireBullet()
    {
        Rigidbody rb = GetComponent<Rigidbody>();

        // Calculate force based on speed and mass
        Vector3 force = transform.TransformDirection(transform.forward) * forwardForce * rb.mass;

        // Apply force to the bullet
        rb.AddForce(force, ForceMode.Impulse);

        // Destroy the bullet after its lifetime expires
        Destroy(gameObject, _lifeTime);
    }

    void ResetBullet()
    {
        _bulletFired = false;
        transform.localPosition = _localPosition;
        Debug.Log($"{nameof(ResetBullet)}");
    }

    public override void FixedUpdateNetwork()
    {

       
    }
}
