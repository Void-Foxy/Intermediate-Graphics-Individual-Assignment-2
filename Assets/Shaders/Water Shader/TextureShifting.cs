using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureShifting : MonoBehaviour {

  Material material;
  float timer;
  [SerializeField] float cycleTime = 1;
  [SerializeField] List<string> texName;
  [SerializeField] bool xPositive;
  [SerializeField] bool yPositive;
  void Start() {
    //Fetch the Material from the Renderer of the GameObject
    material = GetComponent<Renderer>().material;
  }
  private void Update() {
    timer += Time.deltaTime;
    if (timer > cycleTime) {
      timer -= cycleTime;
    }
    for (int i = 0; i < texName.Count; i++) {
      float x;
      float y;
      if (xPositive) {
        x = timer / cycleTime;
      } else {
        x = -timer / cycleTime;
      }
      if (yPositive) {
        y = timer / cycleTime;
      } else {
        y = -timer / cycleTime;
      }
      material.SetTextureOffset(texName[i], new Vector2(x, y));
    }
  }
}
