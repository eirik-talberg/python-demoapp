from demoapp.main import run


def test_demoapp_output():
    expected = "Hello from the demoapp"

    actual = run()

    assert actual == expected
