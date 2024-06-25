using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponTest1 : MonoBehaviour
{
    [SerializeField] private Transform parent;
    [SerializeField] private Transform bullet;
    [SerializeField] private List<Transform> bullets;

    // Start is called before the first frame update
    void Start()
    {
        bullets = new List<Transform>();
        for(int i = 0; i < 10; i++)
        {
           var bullet_ = Instantiate(bullet, parent);
            bullets.Add(bullet_);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
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
    }

    Transform GetBulletFromPool()
    {
        Transform _bullet = null;
        foreach(var bullet in bullets)
        {
            if (!bullet.gameObject.activeInHierarchy)
            {
                _bullet = bullet;
            }
        }
        return _bullet;
    }

}
