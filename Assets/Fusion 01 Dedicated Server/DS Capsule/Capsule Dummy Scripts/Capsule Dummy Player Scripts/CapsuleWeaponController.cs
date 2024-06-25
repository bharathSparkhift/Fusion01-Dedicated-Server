using Cinemachine;
using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CapsuleWeaponController : NetworkBehaviour
{
    [SerializeField] Transform gun;
    [SerializeField] float rayLength;
    [SerializeField] LayerMask layerMask;
    [SerializeField] Transform nozzleEnd;
    [SerializeField] Transform bulletParent;
    [SerializeField] Transform bullet;
    [SerializeField] List<Transform> bullets;
    

    // Start is called before the first frame update
    void Start()
    {
        bullets = new List<Transform>();
        for (int i = 0; i < 10; i++)
        {
            var bullet_ = Instantiate(bullet, bulletParent);
            bullets.Add(bullet_);
        }
    }


    public void FireBullet()
    {
        if (bullets.Count > 0)
        {
            bullet = GetBulletFromPool();
            bullet.gameObject.SetActive(true);
        }
        else
        {
            Debug.Log("<color=yellow>out of ammo</color>");
        }
    }

    Transform GetBulletFromPool()
    {
        Transform _bullet = null;
        foreach (var bullet in bullets)
        {
            if (!bullet.gameObject.activeInHierarchy)
            {
                _bullet = bullet;
            }
        }
        return _bullet;
    }

    public override void Render()
    {
        Debug.DrawRay(nozzleEnd.position, nozzleEnd.forward * rayLength, Color.red);
    }

    public override void FixedUpdateNetwork()
    {

        var options = HitOptions.IgnoreInputAuthority;
        LagCompensatedHit hit;
        Runner.LagCompensation.Raycast(nozzleEnd.position, nozzleEnd.forward, rayLength, player: Object.InputAuthority, out hit, layerMask, options);

        
        Debug.Log($"Hit point {hit.Point}");
    }


    public void RotateGunUpDown(float value)
    {
        // gun.localRotation = Quaternion.Euler(0, -4, 0);
    }


}
