using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderTimeShift : MonoBehaviour
{
  Material material;
  float timer;
  [SerializeField] float cycleTime = 1;
  public float temp;
  string timeShift;
  [SerializeField] bool loopToStart;
  void Start() {
    //Fetch the Material from the Renderer of the GameObject
    material = GetComponent<Renderer>().material;
    timeShift = "_TimeShift";
  }
  private void Update() {
    timer += Time.deltaTime;
    if (timer > cycleTime) {
      timer -= cycleTime;
    }
    if (loopToStart) {
      temp = timer / cycleTime;
      material.SetFloat(timeShift, temp);
    } else if (timer < cycleTime / 2) {
      temp = (timer / (cycleTime / 2));
      material.SetFloat(timeShift, temp);
    } else {
      temp = (1 - ((timer - (cycleTime / 2)) / (cycleTime / 2)));
      material.SetFloat(timeShift, temp);
    }
  }
}
