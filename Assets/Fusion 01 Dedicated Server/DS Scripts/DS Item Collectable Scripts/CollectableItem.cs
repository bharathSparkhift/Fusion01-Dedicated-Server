using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectableItem : NetworkBehaviour
{

    public enum ItemName
    {
        Gold,
        Silver,
        Bronze
    }

    public ItemName ItemNameEnum;

    public delegate void CollectableItemDelegate(CollectableItem collectableItem);
    public static event CollectableItemDelegate CollectableItemHandler;


    #region Monobehaviour callbacks
    // Start is called before the first frame update
    void Start()
    {
        
    }

    #endregion


    public void CollectItem()
    {
        CollectableItemHandler?.Invoke(this);
        DisableGameObject();
    }

    
    /// <summary>
    /// Returns the item name Enum value
    /// </summary>
    /// <returns></returns>
    /*public int GetItemNameEnumValue()
    {
        return (int)ItemNameEnum;
    }*/

    /// <summary>
    /// Disable the game object
    /// </summary>
    public void DisableGameObject()
    {
        gameObject.SetActive(false);
    }

}
