using UnityEngine;
using System.Collections;

public class TakeDamageScript : MonoBehaviour
{
	[SerializeField] Material shaderMat;

	[SerializeField] float fadeSpeed = 2;

	void Update()
	{
		if (Input.GetKeyDown(KeyCode.Space))
		{
			StartCoroutine(TakeDamage());
		}
	}

	IEnumerator TakeDamage()
	{
		float damage = 1;

		while (damage > 0)
		{
			shaderMat.SetFloat("_Damage", damage);

			yield return null;

			damage -= Time.deltaTime * fadeSpeed;
		}

		shaderMat.SetFloat("_Damage", 0);
	}
}
