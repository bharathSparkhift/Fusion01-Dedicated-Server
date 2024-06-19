using Fusion;

public class BagPackage : NetworkBehaviour
{
    [Networked] public int GoldCount { get; set; }

    [Networked] public int SilverCount {  get; set; }
    [Networked] public int BronzeCount  { get; set; }

    [Networked]
    [Capacity(4)] 
    [UnitySerializeField] 
    private NetworkDictionary<int, int> NetDict => default;

    #region
    void Start()
    {
        
    }
    #endregion


    public void AddItemsToBag(int value)
    {
        if(value ==  0)
        {
            GoldCount += 1;
            NetDict.Add(0, GoldCount);
        }else if(value == 1)
        {
            SilverCount += 1;
            NetDict.Add(1, SilverCount);
        }
        else if (value == 2)
        {
            BronzeCount += 1;
            NetDict.Add(2, BronzeCount);
        }
    }

    #region Private methods
    
    #endregion

}
