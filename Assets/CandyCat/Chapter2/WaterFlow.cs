using UnityEngine;  
using System.Collections;  
  
public class WaterFlow : MonoBehaviour {  
  
    public float m_SpeedU = 0.1f;  
    public float m_SpeedV = -0.1f;  

    private Renderer _renderer;
    void Start()
    {
		_renderer=this.GetComponent<Renderer>();
    }

    // Update is called once per frame  
    void Update () {  
        float newOffsetU = Time.time * m_SpeedU;  
        float newOffsetV = Time.time * m_SpeedV;  
  
		if (_renderer)  
        {  
			_renderer.material.mainTextureOffset = new Vector2(newOffsetU, newOffsetV);  
        }  
    }  
}  